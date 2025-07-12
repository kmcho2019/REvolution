module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] counter; // state: count of consecutive ones saturating at 7

    wire [2:0] next_counter;
    wire       counting_en;

    // Enable counting only when input=1, freeze at zero otherwise to reduce toggling
    assign counting_en = in;

    // Next state logic for counter (consecutive ones count)
    assign next_counter = (counting_en) ? ((counter < 3'd7) ? (counter + 3'd1) : 3'd7) : 3'd0;

    // Output logic: Moore outputs depend solely on the current state counter
    // disc for state=5 (means previous input sequence ended with 5 ones + next zero)
    // flag for state=6 (6 ones + next zero)
    // err for state=7 or more (7+ ones)

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            counter <= next_counter;

            // Outputs are based on current state (counter), representing the count of consecutive ones ending last cycle
            // Because counter increments on 'in' and resets on zero, outputs reflect previous cycle's sequences naturally
            disc <= (counter == 3'd5);
            flag <= (counter == 3'd6);
            err  <= (counter == 3'd7);
        end
    end

endmodule