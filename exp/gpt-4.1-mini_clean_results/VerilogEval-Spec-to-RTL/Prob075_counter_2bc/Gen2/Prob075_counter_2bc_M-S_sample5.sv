module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else if (train_valid) begin
            if (train_taken)
                state <= (state == 2'b11) ? 2'b11 : state + 1'b1;
            else
                state <= (state == 2'b00) ? 2'b00 : state - 1'b1;
        end
    end

endmodule