module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [1:0] window1; // Stores bits [3:2] of the sequence
    reg [1:0] window2; // Stores bits [2:1] of the sequence
    reg [1:0] window3; // Stores bits [1:0] of the sequence

    wire partial_match1 = (window1 == 2'b11);
    wire partial_match2 = (window2 == 2'b10);
    wire partial_match3 = (window3 == 2'b01);
    wire sequence_match = partial_match1 & partial_match2 & partial_match3 & data;

    always @(posedge clk) begin
        if (reset) begin
            window1 <= 2'b0;
            window2 <= 2'b0;
            window3 <= 2'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            // Shift in new data to all windows
            window1 <= {window1[0], data};
            window2 <= {window2[0], data};
            window3 <= {window3[0], data};
            
            // Check for sequence match
            start_shifting <= sequence_match;
        end
    end

endmodule