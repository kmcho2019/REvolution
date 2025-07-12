module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    reg [31:0] acc = 32'b0; // accumulated input bits
    reg [31:0] res = 32'b0; // final result
    reg [4:0]  counter = 5'b0; // counter for number of bits received
    reg [31:0] ones = 32'b1; // register with all bits set to 1

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            acc <= 32'b0;
            counter <= 5'b0;
            res <= 32'b0;
        end else begin
            if (counter == 5'b0) begin // idle state
                acc <= 32'b0;
                counter <= 5'b1;
            end else begin // running state
                acc <= {acc[30:0], ~x}; // invert input bit and accumulate
                counter <= counter + 1'b1;
                res <= acc + 32'b1; // add 1 to get 2's complement
            end
        end
    end

    assign z = res[0]; // output the least significant bit of the result

endmodule