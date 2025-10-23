module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// One-hot encoded states
reg [3:0] state;
localparam IDLE = 4'b0001;
localparam S1   = 4'b0010;
localparam S10  = 4'b0100;
localparam S100 = 4'b1000;

// Clock gating control
wire clk_enable = !(state == IDLE && !data_in);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else if (clk_enable) begin
        case (state)
            IDLE: state <= data_in ? S1 : IDLE;
            S1:   state <= data_in ? S1 : S10;
            S10:  state <= data_in ? S1 : S100;
            S100: state <= data_in ? IDLE : IDLE;
            default: state <= IDLE;
        endcase
        
        // Registered output (detected when in S100 and input is 1)
        sequence_detected <= (state == S100) & data_in;
    end
end

endmodule