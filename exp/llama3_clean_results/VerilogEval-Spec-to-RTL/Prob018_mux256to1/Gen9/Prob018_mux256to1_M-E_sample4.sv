module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output out // 1-bit output
);

    wire [255:0] one_hot; // one-hot encoded signal

    // binary decoder to generate one-hot encoded signal
    always @(*) begin
        one_hot = 256'b0; // initialize one-hot signal to zero
        one_hot[sel] = 1'b1; // set corresponding bit to one
    end

    // AND-OR logic to select output from input vector
    assign out = (in & one_hot) != 256'b0; // select output using one-hot signal

endmodule