module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] counter, next_counter;

    // Combinational next state logic (saturating counter)
    always @(*) begin
        if (in) begin
            if (counter < 3'd7)
                next_counter = counter + 3'd1;
            else
                next_counter = 3'd7;
        end else begin
            next_counter = 3'd0;
        end
    end

    // Sequential logic: update counter and outputs synchronously
    // Outputs are Moore-type: depend only on previous counter state
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            // Save previous counter state for output logic
            reg [2:0] prev_counter;
            prev_counter = counter;

            counter <= next_counter;

            // Moore outputs: asserted 1 cycle after detection conditions

            // disc: previous count == 5 and now zero (zero after five ones)
            disc <= (prev_counter == 3'd5) && (next_counter == 3'd0);

            // flag: previous count == 6 and now zero (zero after six ones)
            flag <= (prev_counter == 3'd6) && (next_counter == 3'd0);

            // err: previous count == 7 (already error) or new count saturated at 7
            err <= (prev_counter == 3'd7) || (next_counter == 3'd7);
        end
    end

endmodule