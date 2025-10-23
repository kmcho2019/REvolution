module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output reg  shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            shift_ena <= 1'b1;
        end else if (shift_ena) begin
            if (count == 3'd4) begin
                shift_ena <= 1'b0;
            end else begin
                count <= count + 3'd1;
            end
        end
    end

endmodule