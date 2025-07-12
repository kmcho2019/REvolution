module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding using localparams (no enums)
    localparam S0  = 4'd0; // 0 consecutive ones
    localparam S1  = 4'd1; // 1 consecutive one
    localparam S2  = 4'd2;
    localparam S3  = 4'd3;
    localparam S4  = 4'd4;
    localparam S5  = 4'd5;
    localparam S6  = 4'd6;
    localparam S5D = 4'd7; // discard output asserted state
    localparam S6F = 4'd8; // flag output asserted state
    localparam S7E = 4'd9; // error state

    reg [3:0] state, next_state;

    // Sequential logic: state update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;

            // Default outputs are zero
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;

            // Assert outputs based on current state (Moore outputs)
            case (state)
                S5D: disc <= 1'b1;
                S6F: flag <= 1'b1;
                S7E: err  <= 1'b1;
                default: ; // no output
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;

            S5: next_state = in ? S6 : S5D;
            S5D: next_state = S0;

            S6: next_state = in ? S7E : S6F;
            S6F: next_state = S0;

            S7E: next_state = in ? S7E : S0;

            default: next_state = S0;
        endcase
    end

endmodule