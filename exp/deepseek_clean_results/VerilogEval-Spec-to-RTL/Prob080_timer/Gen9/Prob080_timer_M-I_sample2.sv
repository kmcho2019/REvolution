module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter = 0;
    wire gated_clk = clk & (~tc | load);  // Clock gating when not counting
    assign tc = (counter == 10'b0);       // Simplified zero detection

    always @(posedge gated_clk) begin
        if (load) begin
            counter <= data;
        end else if (~tc) begin
            // Carry-lookahead decrementer
            counter[0] <= ~counter[0];
            counter[1] <= counter[1] ^ ~counter[0];
            counter[2] <= counter[2] ^ &(~counter[1:0]);
            counter[3] <= counter[3] ^ &(~counter[2:0]);
            counter[4] <= counter[4] ^ &(~counter[3:0]);
            counter[5] <= counter[5] ^ &(~counter[4:0]);
            counter[6] <= counter[6] ^ &(~counter[5:0]);
            counter[7] <= counter[7] ^ &(~counter[6:0]);
            counter[8] <= counter[8] ^ &(~counter[7:0]);
            counter[9] <= counter[9] ^ &(~counter[8:0]);
        end
    end

endmodule