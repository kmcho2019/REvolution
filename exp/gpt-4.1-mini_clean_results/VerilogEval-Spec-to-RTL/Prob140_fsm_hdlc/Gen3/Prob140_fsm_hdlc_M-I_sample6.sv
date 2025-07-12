module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [3:0] {
        S0    = 4'd0, // 0 consecutive ones
        S1    = 4'd1,
        S2    = 4'd2,
        S3    = 4'd3,
        S4    = 4'd4,
        S5    = 4'd5,
        S6    = 4'd6,
        DISC  = 4'd7, // output disc=1 for one cycle
        FLAG  = 4'd8, // output flag=1 for one cycle
        ERR   = 4'd9  // output err=1 for one cycle
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
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
                else
                    next_state = DISC;  // detected 5 ones then zero -> disc output next cycle
            end

            S6: begin
                if (in)
                    next_state = ERR;   // detected 7 or more ones -> err output next cycle
                else
                    next_state = FLAG;  // detected 6 ones then zero -> flag output next cycle
            end

            DISC: begin
                next_state = S0; // output one cycle, then reset count
            end

            FLAG: begin
                next_state = S0; // output one cycle, then reset count
            end

            ERR: begin
                next_state = S0; // output one cycle, then reset count
            end

            default: next_state = S0;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;

            // Outputs depend only on current state (Moore)
            disc <= (next_state == DISC);
            flag <= (next_state == FLAG);
            err  <= (next_state == ERR);
        end
    end

endmodule