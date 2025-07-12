module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit state: count of consecutive ones (0..6),
    // 7 means error state (7 or more ones)
    reg [2:0] count, next_count;

    // Next count logic: 
    // - if input=1 and count<6, count increments
    // - if input=1 and count=6, next_count=7 (error)
    // - if input=0 and count=5, disc pulse next cycle
    // - if input=0 and count=6, flag pulse next cycle
    // - if input=0 and other count, reset count=0
    always @(*) begin
        case (count)
            3'd0: next_count = (in) ? 3'd1 : 3'd0;
            3'd1: next_count = (in) ? 3'd2 : 3'd0;
            3'd2: next_count = (in) ? 3'd3 : 3'd0;
            3'd3: next_count = (in) ? 3'd4 : 3'd0;
            3'd4: next_count = (in) ? 3'd5 : 3'd0;
            3'd5: next_count = (in) ? 3'd6 : 3'd0;
            3'd6: next_count = (in) ? 3'd7 : 3'd0;
            3'd7: next_count = (in) ? 3'd7 : 3'd0;
            default: next_count = 3'd0;
        endcase
    end

    // Output logic: all outputs are one-cycle pulses starting one cycle after condition detection
    // Generate outputs based on previous count and current input to detect conditions:

    // Condition detection variables
    wire disc_detect = (count == 3'd5) && (in == 1'b0);  // 5 consecutive ones then 0 -> discard bit
    wire flag_detect = (count == 3'd6) && (in == 1'b0);  // 6 consecutive ones then 0 -> flag
    wire err_detect  = (count == 3'd7);                   // 7 or more consecutive ones -> error

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            count <= next_count;

            // Outputs pulse high for one cycle after detection
            disc <= disc_detect;
            flag <= flag_detect;
            err  <= err_detect;
        end
    end

endmodule