module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: 0-6 count consecutive ones, 7 = error state (7 or more ones)
    reg [2:0] state;
    reg [2:0] next_state;

    // Internal signals for outputs before registering
    reg disc_int, flag_int, err_int;

    // Combinational next state and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        disc_int   = 1'b0;
        flag_int   = 1'b0;
        err_int    = 1'b0;

        case (state)
            3'd0: begin
                if (in)
                    next_state = 3'd1;
                else
                    next_state = 3'd0;
            end
            3'd1: begin
                if (in)
                    next_state = 3'd2;
                else
                    next_state = 3'd0;
            end
            3'd2: begin
                if (in)
                    next_state = 3'd3;
                else
                    next_state = 3'd0;
            end
            3'd3: begin
                if (in)
                    next_state = 3'd4;
                else
                    next_state = 3'd0;
            end
            3'd4: begin
                if (in)
                    next_state = 3'd5;
                else
                    next_state = 3'd0;
            end
            3'd5: begin
                if (in) begin
                    next_state = 3'd6;
                end else begin
                    // sequence 0111110 detected: one zero after 5 ones, discard this zero bit
                    next_state = 3'd0;
                    disc_int = 1'b1;
                end
            end
            3'd6: begin
                if (in) begin
                    // 7 consecutive ones, error
                    next_state = 3'd7;
                    err_int = 1'b1;
                end else begin
                    // sequence 01111110 detected: 6 ones then zero, flag frame boundary
                    next_state = 3'd0;
                    flag_int = 1'b1;
                end
            end
            3'd7: begin
                if (in)
                    next_state = 3'd7; // remain in error state on further ones
                else
                    next_state = 3'd0; // reset counting after zero
                err_int = 1'b1;
            end
            default: begin
                next_state = 3'd0;
            end
        endcase
    end

    // Sequential logic: update state and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
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