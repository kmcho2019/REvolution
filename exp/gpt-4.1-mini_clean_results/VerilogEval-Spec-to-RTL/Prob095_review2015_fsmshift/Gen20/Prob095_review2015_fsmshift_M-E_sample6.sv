module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output reg  shift_ena
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd1;
            shift_ena <= 1'b1;
        end else if (shift_ena) begin
            if (count < 2'd4) begin
                count <= count + 2'd1;
                shift_ena <= 1'b1;
            end else begin
                shift_ena <= 1'b0;
            end
        end
    end

endmodule