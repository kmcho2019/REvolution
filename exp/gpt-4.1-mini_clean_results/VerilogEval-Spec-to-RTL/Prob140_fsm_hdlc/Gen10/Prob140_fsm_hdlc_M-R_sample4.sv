module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot encoded states for 0 to 7 consecutive ones (S0-S7)
    localparam [7:0]
        S0 = 8'b0000_0001,
        S1 = 8'b0000_0010,
        S2 = 8'b0000_0100,
        S3 = 8'b0000_1000,
        S4 = 8'b0001_0000,
        S5 = 8'b0010_0000,
        S6 = 8'b0100_0000,
        S7 = 8'b1000_0000; // error state: 7 or more consecutive ones

    reg [7:0] state, next_state;

    // Next state combinational logic using one-hot encoding
    wire [7:0] next_state_w;

    assign next_state_w =
        (state == S0) ? (in ? S1 : S0) :
        (state == S1) ? (in ? S2 : S0) :
        (state == S2) ? (in ? S3 : S0) :
        (state == S3) ? (in ? S4 : S0) :
        (state == S4) ? (in ? S5 : S0) :
        (state == S5) ? (in ? S6 : S0) :
        (state == S6) ? (in ? S7 : S0) :
        (state == S7) ? (in ? S7 : S0) :
        S0;

    // Combinational outputs based on current state and input
    wire disc_w = (state == S5) && (in == 1'b0);
    wire flag_w = (state == S6) && (in == 1'b0);
    // err asserted if next state is S7 (error detected this cycle or continuing error)
    wire err_w  = (next_state_w == S7);

    // Sequential logic: state register and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state_w;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule