module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output reg  shift_ena
);

    reg [2:0] counter;
    reg [2:0] next_counter;

    always @* begin
        if (reset) begin
            next_counter = 3'd4;
        end else if (counter != 3'd0) begin
            next_counter = counter - 1;
        end else begin
            next_counter = 3'd0;
        end
    end

    always @(posedge clk) begin
        counter <= next_counter;
        shift_ena <= (next_counter != 3'd0);
    end

endmodule