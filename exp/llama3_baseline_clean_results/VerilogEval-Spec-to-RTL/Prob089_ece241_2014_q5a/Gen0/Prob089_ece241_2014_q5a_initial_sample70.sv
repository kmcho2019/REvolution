module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [7:0] output; // assuming we're working with 8-bit numbers, can be adjusted
reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        output <= 8'd0; // reset output
        carry <= 1'b0; // reset carry
    end else begin
        if (~x) begin // if input is '0', we're done with the number
            output <= ~output + 1; // calculate 2's complement
        end else begin
            carry <= x; // set carry for the next bit
            output <= {output[6:0], ~x ^ carry}; // shift and append new bit
        end
    end
end

assign z = output[0]; // output the least significant bit

endmodule