module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    // Use uniform 4-bit encoding for all states (0-9 states):
    localparam [3:0]
        S0 = 4'd0,  // zero consecutive ones
        S1 = 4'd1,
        S2 = 4'd2,
        S3 = 4'd3,
        S4 = 4'd4,
        S5 = 4'd5,
        S6 = 4'd6,
        SO = 4'd7,  // output state: disc or flag output asserted
        SE = 4'd8;  // error state: 7 or more consecutive ones

    reg [3:0] state, next_state;

    // Next state and output indication combinational logic
    // output_type:
    // 0 = no output
    // 1 = disc output (discard bit)
    // 2 = flag output
    reg [1:0] output_type;
    reg [1:0] next_output_type;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_output_type = 2'd0;

        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: begin
                if (in)
                    next_state = S6;
                else begin
                    next_state = SO;
                    next_output_type = 2'd1; // disc output
                end
            end
            S6: begin
                if (in)
                    next_state = SE;
                else begin
                    next_state = SO;
                    next_output_type = 2'd2; // flag output
                end
            end
            SO: begin
                next_state = S0;
                next_output_type = 2'd0; // outputs asserted only one cycle in SO
            end
            SE: next_state = in ? SE : S0;
            default: begin
                next_state = S0;
                next_output_type = 2'd0;
            end
        endcase
    end

    // State register update
    reg [1:0] output_type_reg;
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            output_type_reg <= 2'd0;
        end else begin
            state <= next_state;
            output_type_reg <= next_output_type;
        end
    end

    // Outputs combinational from state and output_type_reg (Moore outputs)
    // Outputs asserted for one full cycle in SO state according to output_type_reg
    assign disc = (state == SO) && (output_type_reg == 2'd1);
    assign flag = (state == SO) && (output_type_reg == 2'd2);
    assign err  = (state == SE);

endmodule