module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot state encoding
    localparam S0 = 8'b00000001;
    localparam S1 = 8'b00000010;
    localparam S2 = 8'b00000100;
    localparam S3 = 8'b00001000;
    localparam S4 = 8'b00010000;
    localparam S5 = 8'b00100000;
    localparam S6 = 8'b01000000;
    localparam S7 = 8'b10000000;

    reg [7:0] state;

    // Next state logic using continuous assignments
    wire [7:0] next_state;
    assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[5] | state[6])) | 
                          (~in & state[7]);
    assign next_state[1] = in & state[0];
    assign next_state[2] = in & state[1];
    assign next_state[3] = in & state[2];
    assign next_state[4] = in & state[3];
    assign next_state[5] = in & state[4];
    assign next_state[6] = in & state[5];
    assign next_state[7] = in & (state[6] | state[7]);

    // Output logic
    wire next_disc = state[5] & ~in;
    wire next_flag = state[6] & ~in;
    wire next_err  = (state[6] | state[7]) & in;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            disc <= next_disc;
            flag <= next_flag;
            err <= next_err;
        end
    end

endmodule