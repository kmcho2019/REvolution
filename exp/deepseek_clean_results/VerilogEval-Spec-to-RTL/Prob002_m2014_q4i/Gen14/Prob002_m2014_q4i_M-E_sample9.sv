module TopModule (
    output out
);
    reg [1:0] counter = 2'b00;
    wire clk = 1'b0;  // Permanently disabled clock
    wire reset = 1'b0; // Never reset
    wire enable = 1'b0; // Counter permanently disabled

    always @(posedge clk or posedge reset) begin
        if (reset)
            counter <= 2'b00;
        else if (enable)
            counter <= counter - 1;
    end

    assign out = counter[0]; // Will always be 0
endmodule