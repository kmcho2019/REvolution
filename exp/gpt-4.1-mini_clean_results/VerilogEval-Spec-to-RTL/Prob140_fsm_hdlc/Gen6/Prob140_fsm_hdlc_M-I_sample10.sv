module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot encoded states: 8 states => 8 flip-flops
    // States: S0..S7
    localparam S0 = 8'b0000_0001;
    localparam S1 = 8'b0000_0010;
    localparam S2 = 8'b0000_0100;
    localparam S3 = 8'b0000_1000;
    localparam S4 = 8'b0001_0000;
    localparam S5 = 8'b0010_0000;
    localparam S6 = 8'b0100_0000;
    localparam S7 = 8'b1000_0000; // error state

    reg [7:0] state, next_state;
    reg prev_in;
    reg [7:0] prev_state;

    // Next state logic combinational
    always @(*) begin
        // Default next state is S0 (safe)
        next_state = S0;

        case (1'b1)
            state[0]: next_state = in ? S1 : S0; // S0
            state[1]: next_state = in ? S2 : S0; // S1
            state[2]: next_state = in ? S3 : S0; // S2
            state[3]: next_state = in ? S4 : S0; // S3
            state[4]: next_state = in ? S5 : S0; // S4
            state[5]: next_state = in ? S6 : S0; // S5
            state[6]: next_state = in ? S7 : S0; // S6
            state[7]: next_state = in ? S7 : S0; // S7 (error stays or reset on 0)
            default: next_state = S0;
        endcase
    end

    // Sequential logic: update state, prev_in, prev_state, and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            prev_state <= S0;
            prev_in <= 1'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            // Update states and inputs
            prev_state <= state;
            prev_in <= in;
            state <= next_state;

            // Outputs:
            // disc = prev_state==S5 && prev_in==1 && current in==0
            // flag = prev_state==S6 && prev_in==1 && current in==0
            // err = current state == S7

            disc <= (prev_state == S5) && (prev_in == 1'b1) && (in == 1'b0);
            flag <= (prev_state == S6) && (prev_in == 1'b1) && (in == 1'b0);
            err  <= (next_state == S7);
        end
    end

endmodule