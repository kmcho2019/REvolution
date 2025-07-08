module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // States represent number of consecutive 1s counted (0 to 7)
    // 7 means error (7 or more consecutive 1s)
    reg [3:0] state, next_state;

    // Internal registers to hold previous state and input to generate outputs on next cycle
    reg [3:0] prev_state;
    reg       prev_in;

    // State transition logic
    always @(*) begin
        case (state)
            4'd0: begin
                if (in)
                    next_state = 4'd1;
                else
                    next_state = 4'd0;
            end
            4'd1: begin
                if (in)
                    next_state = 4'd2;
                else
                    next_state = 4'd0;
            end
            4'd2: begin
                if (in)
                    next_state = 4'd3;
                else
                    next_state = 4'd0;
            end
            4'd3: begin
                if (in)
                    next_state = 4'd4;
                else
                    next_state = 4'd0;
            end
            4'd4: begin
                if (in)
                    next_state = 4'd5;
                else
                    next_state = 4'd0;
            end
            4'd5: begin
                if (in)
                    next_state = 4'd6;
                else
                    next_state = 4'd0;
            end
            4'd6: begin
                if (in)
                    next_state = 4'd7; // error state
                else
                    next_state = 4'd0;
            end
            4'd7: begin
                // stay in error state until reset
                next_state = 4'd7;
            end
            default: next_state = 4'd0;
        endcase
    end

    // Sequential logic for state update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 4'd0;
            prev_state <= 4'd0;
            prev_in <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            state <= next_state;
            prev_state <= state;
            prev_in <= in;

            // Reset outputs by default
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;

            // Outputs depend on previous state and previous input (Moore style, one cycle delayed)
            // Condition (1) disc: previous state = 5 and previous input=0 -> discard inserted zero bit
            if ((prev_state == 4'd5) && (prev_in == 1'b0)) begin
                disc <= 1'b1;
            end

            // Condition (2) flag: previous state = 6 and previous input=0 -> flag detected
            if ((prev_state == 4'd6) && (prev_in == 1'b0)) begin
                flag <= 1'b1;
            end

            // Condition (3) err: state 7 or more consecutive 1s (error state) asserted immediately in error state
            if (prev_state == 4'd7) begin
                err <= 1'b1;
            end
        end
    end

endmodule