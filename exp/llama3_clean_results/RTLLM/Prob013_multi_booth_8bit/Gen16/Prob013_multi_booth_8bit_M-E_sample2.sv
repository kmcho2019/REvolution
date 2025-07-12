module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Partial product generation for the first 4-bit segment
reg [15:0] pp0, pp1, pp2, pp3;

// Partial product generation for the second 4-bit segment
reg [15:0] pp4, pp5, pp6, pp7;

// Accumulator pipeline stages
reg [15:0] acc0, acc1, acc2, acc3;

// Final product register
reg [15:0] product;

// Control signals for Booth encoding
reg [1:0] booth_ctl0, booth_ctl1;

// Ready signal and counter
reg rdy_reg;
reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        // Reset all registers and signals
        pp0 <= 0; pp1 <= 0; pp2 <= 0; pp3 <= 0;
        pp4 <= 0; pp5 <= 0; pp6 <= 0; pp7 <= 0;
        acc0 <= 0; acc1 <= 0; acc2 <= 0; acc3 <= 0;
        product <= 0;
        booth_ctl0 <= 0; booth_ctl1 <= 0;
        rdy_reg <= 0;
        counter <= 0;
    end else begin
        // Parallel partial product generation for the first 4-bit segment
        case (booth_ctl0)
            2'b00: begin pp0 <= {{8{1'b0}}, a}; pp1 <= {{8{1'b0}}, a}; end
            2'b01: begin pp0 <= {{8{1'b0}}, a}; pp1 <= {{8{1'b0}}, a} << 1; end
            2'b10: begin pp0 <= {{8{1'b0}}, a} << 1; pp1 <= {{8{1'b0}}, a} << 1; end
            2'b11: begin pp0 <= {{8{1'b0}}, a} << 1; pp1 <= {{8{1'b0}}, a} << 2; end
        endcase

        // Parallel partial product generation for the second 4-bit segment
        case (booth_ctl1)
            2'b00: begin pp4 <= {{8{1'b0}}, a}; pp5 <= {{8{1'b0}}, a}; end
            2'b01: begin pp4 <= {{8{1'b0}}, a}; pp5 <= {{8{1'b0}}, a} << 1; end
            2'b10: begin pp4 <= {{8{1'b0}}, a} << 1; pp5 <= {{8{1'b0}}, a} << 1; end
            2'b11: begin pp4 <= {{8{1'b0}}, a} << 1; pp5 <= {{8{1'b0}}, a} << 2; end
        endcase

        // Pipelined accumulation
        acc0 <= pp0 + pp1;
        acc1 <= acc0 + pp4;
        acc2 <= acc1 + pp5;
        acc3 <= acc2 + pp7;

        // Final product formation
        product <= acc3;

        // Booth encoding control
        booth_ctl0 <= b[7:6];
        booth_ctl1 <= b[5:4];

        // Ready signal and counter
        if (counter == 4'd15) begin
            rdy_reg <= 1;
        end else begin
            counter <= counter + 1;
        end
    end
end

assign p = product;
assign rdy = rdy_reg;

endmodule