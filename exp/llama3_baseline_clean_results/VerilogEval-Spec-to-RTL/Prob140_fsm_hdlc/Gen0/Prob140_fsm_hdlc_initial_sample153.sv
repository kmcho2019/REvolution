module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    // Define states
    reg [3:0] state;
    parameter IDLE = 4'b0000;
    parameter S1 = 4'b0001;
    parameter S2 = 4'b0010;
    parameter S3 = 4'b0011;
    parameter S4 = 4'b0100;
    parameter S5 = 4'b0101;
    parameter S6 = 4'b0110;
    parameter S7 = 4'b0111;
    parameter ERR = 4'b1000;

    // Initialize state to IDLE
    initial state = IDLE;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (in) state <= S1; else state <= IDLE;
                S1: if (in) state <= S2; else state <= IDLE;
                S2: if (in) state <= S3; else state <= IDLE;
                S3: if (in) state <= S4; else state <= IDLE;
                S4: if (in) state <= S5; else state <= IDLE;
                S5: if (in) state <= S6; else if (!in) state <= IDLE; else state <= S5; // Discard the zero
                S6: if (in) state <= S7; else if (!in) state <= IDLE; else state <= S6; // Flag detected, go to IDLE
                S7: if (in) state <= ERR; else state <= IDLE;
                ERR: if (in) state <= ERR; else state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Combinational logic for outputs
    always @(*) begin
        disc = (state == S5); // Discard the zero after 5 consecutive 1s
        flag = (state == S6); // Flag detected
        err = (state == S7 || state == ERR); // Error detected
    end

endmodule