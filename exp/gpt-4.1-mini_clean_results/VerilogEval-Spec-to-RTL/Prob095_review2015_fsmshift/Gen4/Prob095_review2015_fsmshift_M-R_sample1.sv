module TopModule (
    input  wire clk,
    input  wire reset,
    output wire shift_ena
);

    reg [2:0] counter;
    reg [2:0] next_counter;

    // Counter update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd4;    // Initialize counter to 4 on reset
        end else begin
            counter <= next_counter;
        end
    end

    // Next counter logic
    always @(*) begin
        if (counter != 0)
            next_counter = counter - 1;
        else
            next_counter = 3'd0;
    end

    // shift_ena asserted while counter is nonzero
    assign shift_ena = (counter != 0);

endmodule