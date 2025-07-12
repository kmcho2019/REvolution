module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [2:0] msg_progress;

    // Shift register operation:
    // - Reset: 100 (ready to detect first byte)
    // - Normal operation: shift left and set LSB when appropriate
    always @(posedge clk) begin
        if (reset) begin
            msg_progress <= 3'b100;
        end else begin
            if (msg_progress[2]) begin
                // In detection phase - look for start byte
                if (in[3]) begin
                    msg_progress <= 3'b001;  // Start new message
                end
            end else begin
                // Shift left and set new LSB
                msg_progress <= {msg_progress[1:0], 1'b1};
            end
        end
    end

    // Done when all three bytes received
    assign done = &msg_progress;

endmodule