module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

// Define the 4-bit BCD counter module
module BCDCounter(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);
    reg [3:0] q_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 4'b0000;
        end else if (ena) begin
            if (q_reg == 4'b1001) begin
                q_reg <= 4'b0000;
            end else begin
                q_reg <= q_reg + 1'b1;
            end
        end
    end
    
    assign q = q_reg;
endmodule

// Instantiate four BCD counters
wire ena_ones, ena_tens, ena_hundreds;
BCDCounter ones_counter(
    .clk(clk),
    .reset(reset),
    .ena(ena_ones),
    .q(q[3:0])
);

BCDCounter tens_counter(
    .clk(clk),
    .reset(reset),
    .ena(ena_tens),
    .q(q[7:4])
);

BCDCounter hundreds_counter(
    .clk(clk),
    .reset(reset),
    .ena(ena_hundreds),
    .q(q[11:8])
);

BCDCounter thousands_counter(
    .clk(clk),
    .reset(reset),
    .ena(1'b1),
    .q(q[15:12])
);

// Generate enable signals
always @(posedge clk) begin
    if (reset) begin
        ena_ones <= 1'b1;
        ena_tens <= 1'b0;
        ena_hundreds <= 1'b0;
    end else begin
        ena_ones <= 1'b1;
        if (q[3:0] == 4'b1001) begin
            ena_tens <= 1'b1;
            if (q[7:4] == 4'b1001) begin
                ena_hundreds <= 1'b1;
                if (q[11:8] == 4'b1001) begin
                    // thousands digit should always be enabled
                end else begin
                    ena_hundreds <= 1'b0;
                end
            end else begin
                ena_tens <= 1'b0;
            end
        end else begin
            ena_tens <= 1'b0;
            ena_hundreds <= 1'b0;
        end
    end
end

assign ena[0] = ena_ones;
assign ena[1] = ena_tens;
assign ena[2] = ena_hundreds;

endmodule