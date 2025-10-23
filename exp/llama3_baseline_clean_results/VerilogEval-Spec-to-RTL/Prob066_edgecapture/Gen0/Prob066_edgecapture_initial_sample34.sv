module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in; // register to store the previous state of the input vector

always @ (posedge clk) begin
    if (reset) begin // active high synchronous reset
        out <= 32'b0; // reset all output bits to 0
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1 && in[i] == 0) begin // detect transition from 1 to 0
                out[i] <= 1; // set the corresponding output bit to 1
            end
        end
        prev_in <= in; // update the previous state register
    end
end

endmodule