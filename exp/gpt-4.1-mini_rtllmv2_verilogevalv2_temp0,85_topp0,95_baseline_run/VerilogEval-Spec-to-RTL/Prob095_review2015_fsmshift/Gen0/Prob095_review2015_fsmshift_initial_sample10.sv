module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    reg [2:0] counter;  // enough to count to 4

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;
            shift_ena <= 1'b1;
        end else begin
            if (counter > 0) begin
                counter <= counter - 1;
                shift_ena <= 1'b1;
            end else begin
                shift_ena <= 1'b0;
            end
        end
    end

endmodule