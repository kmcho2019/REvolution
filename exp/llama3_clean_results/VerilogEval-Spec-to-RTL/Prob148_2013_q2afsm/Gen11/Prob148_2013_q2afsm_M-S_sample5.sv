module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// State flip-flops and output assignments
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00;
        g <= 3'b000;
    end else begin
        case (state)
            2'b00: begin
                if (r[0]) begin
                    state <= 2'b01;
                    g <= 3'b001;
                end else if (r[1]) begin
                    state <= 2'b10;
                    g <= 3'b010;
                end else if (r[2]) begin
                    state <= 2'b11;
                    g <= 3'b001; // Only r2 is requesting
                end else begin
                    state <= 2'b00;
                    g <= 3'b000;
                end
            end
            2'b01: begin
                if (r[0]) begin
                    state <= 2'b01;
                    g <= 3'b001;
                end else begin
                    state <= 2'b00;
                    g <= 3'b000;
                end
            end
            2'b10: begin
                if (r[1]) begin
                    state <= 2'b10;
                    g <= 3'b010;
                end else begin
                    state <= 2'b00;
                    g <= 3'b000;
                end
            end
            2'b11: begin
                if (r[2]) begin
                    state <= 2'b11;
                    g <= 3'b001; // Only r2 is requesting
                end else begin
                    state <= 2'b00;
                    g <= 3'b000;
                end
            end
        endcase
    end
end

endmodule