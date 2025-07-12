module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding:
    // [3] = flag bit indicating a zero just followed consecutive ones (trigger outputs)
    // [2:0] = count of consecutive ones (0..6)
    // State 4-bit: MSB=output trigger, lower bits=ones count
    // State 7 (0b0111) = 7 ones (error)
    // State with MSB=1 means zero after run of ones, wait one cycle to output disc or flag
    reg [3:0] state, next_state;

    // Output signals combinationally from current state
    wire disc_int, flag_int, err_int;

    // Extract count and output trigger bit for clarity
    wire [2:0] count = state[2:0];
    wire out_trig = state[3];

    // Next state logic
    always @(*) begin
        case (state)
            // When output trigger bit is set (MSB=1), return to count 0 on next cycle
            4'b1xxx: next_state = 4'd0;

            default: begin
                if (in == 1'b1) begin
                    if (count < 3'd6)
                        next_state = {1'b0, count + 3'd1}; // increment count
                    else
                        next_state = 4'd7; // error: 7 or more consecutive ones
                end else begin
                    // input zero after run of ones: set MSB to trigger outputs next cycle
                    // only if count is >= 5 for disc or flag, else go to count 0 without trigger
                    if (count >= 3'd5)
                        next_state = {1'b1, count}; // trigger output next cycle
                    else
                        next_state = 4'd0; // reset count to 0 without trigger
                end
            end
        endcase
    end

    // Output logic: decode disc, flag, err from current state
    assign disc_int = (out_trig && (count == 3'd5));
    assign flag_int = (out_trig && (count == 3'd6));
    assign err_int  = (state == 4'd7);

    // Sequential logic: update state and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_int;
            flag  <= flag_int;
            err   <= err_int;
        end
    end

endmodule