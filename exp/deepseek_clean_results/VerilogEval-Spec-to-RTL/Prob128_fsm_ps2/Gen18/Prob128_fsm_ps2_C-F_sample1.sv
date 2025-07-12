module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] shift;

    always @(posedge clk) begin
        if (reset) begin
            shift <= 2'b00;
        end else begin
            if (shift == 2'b00) begin
                if (in[3]) shift <= 2'b01;  // Start new message
            end else begin
                shift <= {shift[0], 1'b0};   // Shift left (01->10->00)
            end
        end
    end

    assign done = (shift == 2'b10);  // Assert during 3rd byte's cycle

endmodule