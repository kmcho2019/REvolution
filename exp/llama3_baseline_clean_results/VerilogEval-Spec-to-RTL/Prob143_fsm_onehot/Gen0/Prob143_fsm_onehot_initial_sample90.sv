module TopModule(
    input  in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Initialize next_state to zero
    assign next_state = 10'd0;

    // Initialize out1 and out2 to zero
    assign out1 = 1'b0;
    assign out2 = 1'b0;

    // State transition logic
    always @(*) begin
        case (1'b1)
            state[0]: // S0
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                end
            state[1]: // S1
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[2] = 1'b1;
                end
            state[2]: // S2
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[3] = 1'b1;
                end
            state[3]: // S3
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[4] = 1'b1;
                end
            state[4]: // S4
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[5] = 1'b1;
                end
            state[5]: // S5
                if (in == 1'b0) begin
                    next_state[8] = 1'b1;
                end else begin
                    next_state[6] = 1'b1;
                end
            state[6]: // S6
                if (in == 1'b0) begin
                    next_state[9] = 1'b1;
                end else begin
                    next_state[7] = 1'b1;
                end
            state[7]: // S7
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[7] = 1'b1;
                end
            state[8]: // S8
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                end
            state[9]: // S9
                if (in == 1'b0) begin
                    next_state[0] = 1'b1;
                end else begin
                    next_state[1] = 1'b1;
                end
            default:
                next_state[0] = 1'b1; // Default to S0
        endcase
    end

    // Output logic
    always @(*) begin
        if (state[7] == 1'b1) begin // S7
            out1 = 1'b0;
            out2 = 1'b1;
        end else if (state[8] == 1'b1) begin // S8
            out1 = 1'b1;
            out2 = 1'b0;
        end else if (state[9] == 1'b1) begin // S9
            out1 = 1'b1;
            out2 = 1'b1;
        end else begin
            out1 = 1'b0;
            out2 = 1'b0;
        end
    end

endmodule