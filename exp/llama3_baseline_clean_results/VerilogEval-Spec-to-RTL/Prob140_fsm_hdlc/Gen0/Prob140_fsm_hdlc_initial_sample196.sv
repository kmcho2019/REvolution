module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define states
enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6, Sflag, Serr, Sdiscard} state, next_state;

// Output signals
logic disc_out, flag_out, err_out;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 0;
        flag <= 0;
        err <= 0;
    end else begin
        state <= next_state;
        disc <= disc_out;
        flag <= flag_out;
        err <= err_out;
    end
end

always_comb begin
    disc_out = 0;
    flag_out = 0;
    err_out = 0;
    
    case (state)
        S0: begin
            if (in) next_state = S1;
            else next_state = S0;
        end
        S1: begin
            if (in) next_state = S2;
            else next_state = S0;
        end
        S2: begin
            if (in) next_state = S3;
            else next_state = S0;
        end
        S3: begin
            if (in) next_state = S4;
            else next_state = S0;
        end
        S4: begin
            if (in) next_state = S5;
            else next_state = S0;
        end
        S5: begin
            if (in) next_state = S6;
            else next_state = S0;
        end
        S6: begin
            if (in) next_state = Serr;
            else begin
                next_state = Sdiscard;
                disc_out = 1;
            end
        end
        Sdiscard: begin
            if (in) next_state = S1;
            else next_state = S0;
        end
        Serr: begin
            if (in) next_state = Serr;
            else begin
                next_state = S0;
                err_out = 1;
            end
        end
        default: begin
            if (in) next_state = S1;
            else next_state = S0;
        end
    endcase
    
    // Assert flag when transitioning from S6 to Sdiscard (01111110 detected)
    if (state == S6 && !in) flag_out = 1;
end

endmodule