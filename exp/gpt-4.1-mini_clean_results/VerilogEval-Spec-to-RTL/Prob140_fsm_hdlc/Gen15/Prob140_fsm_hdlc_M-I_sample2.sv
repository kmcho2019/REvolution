module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: count of consecutive 1s (0..7)
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // error state (7 or more consecutive 1s)

    reg [2:0] state, next_state;

    // Next state combinational logic and output signals combined
    reg disc_int, flag_int, err_int;

    always @(*) begin
        // Default next state and outputs
        disc_int = 1'b0;
        flag_int = 1'b0;
        err_int  = 1'b0;

        case (state)
            S0: begin
                if (in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (in)
                    next_state = S2;
                else
                    next_state = S0;
            end
            S2: begin
                if (in)
                    next_state = S3;
                else
                    next_state = S0;
            end
            S3: begin
                if (in)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (in)
                    next_state = S5;
                else
                    next_state = S0;
            end
            S5: begin
                if (in)
                    next_state = S6;
                else begin
                    next_state = S0;
                    disc_int = 1'b1; // detected 0111110 (run of 5 ones followed by zero)
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7; // error state on 7 consecutive ones
                    err_int = 1'b1;
                end else begin
                    next_state = S0;
                    flag_int = 1'b1; // detected 01111110 (run of 6 ones followed by zero)
                end
            end
            S7: begin
                // Remain in error state if ones continue
                if (in) begin
                    next_state = S7;
                    err_int = 1'b1;
                end else begin
                    next_state = S0;
                    err_int = 1'b1; // maintain error output on this cycle as well
                end
            end
            default: begin
                next_state = S0;
            end
        endcase
    end

    // Sequential logic: state and outputs registered on positive clock edge
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
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