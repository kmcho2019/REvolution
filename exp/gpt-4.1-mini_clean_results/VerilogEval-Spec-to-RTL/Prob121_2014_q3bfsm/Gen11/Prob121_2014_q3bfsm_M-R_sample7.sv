module TopModule(
    input        clk,
    input        reset,
    input        x,
    output reg   z
);

    // State encoding using localparams for clarity
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state, next_state;

    // Combinational block for next state and output logic
    always @(*) begin
        case(state)
            S0: begin
                next_state = x ? S1 : S0;
                z = 1'b0;
            end
            S1: begin
                next_state = x ? S4 : S1;
                z = 1'b0;
            end
            S2: begin
                next_state = x ? S1 : S2;
                z = 1'b0;
            end
            S3: begin
                next_state = x ? S2 : S1;
                z = 1'b1;
            end
            S4: begin
                next_state = x ? S4 : S3;
                z = 1'b1;
            end
            default: begin
                next_state = S0;
                z = 1'b0;
            end
        endcase
    end

    // Sequential block for state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule