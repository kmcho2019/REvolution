module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Create a one-hot encoded signal from the select signal using bitwise operations
    wire [255:0] one_hot = (1 << sel);

    // Alternatively, implement the one-hot encoding using a case statement for clarity
    // wire [255:0] one_hot;
    // always @(*)
    // begin
    //     case (sel)
    //         8'd0: one_hot = 256'd1;
    //         8'd1: one_hot = 256'd2;
    //         // ... (for all 256 cases)
    //         8'd255: one_hot = 256'd256;
    //         default: one_hot = 256'd0;
    //     endcase
    // end

    // Use the one-hot signal to select the desired bit from the input vector
    assign out = in[sel];

endmodule