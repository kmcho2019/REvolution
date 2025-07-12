module TopModule (
    input  wire clk,
    input  wire reset,          // synchronous active-high reset
    input  wire pattern_detected, // 1-cycle pulse indicating the proper bit pattern detected
    output wire shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd4;
        end else if (pattern_detected) begin
            count <= 3'd4;
        end else if (count != 0) begin
            count <= count - 1;
        end
    end

    assign shift_ena = (count != 0);

endmodule