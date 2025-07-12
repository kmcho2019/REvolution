module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Create a one-hot encoded signal from the select signal
    wire [255:0] one_hot;
    assign one_hot = (1 << sel);

    // Use the one-hot signal to select the desired bit from the input vector
    assign out = (in & one_hot) != 0;

endmodule