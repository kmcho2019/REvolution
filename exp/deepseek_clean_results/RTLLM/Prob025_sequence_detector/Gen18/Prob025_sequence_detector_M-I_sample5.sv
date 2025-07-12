module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// One-hot encoded states
localparam IDLE = 4'b0001;
localparam S1   = 4'b0010;
localparam S10  = 4'b0100;
localparam S100 = 4'b1000;

reg [3:0] state, next_state;
reg gated_clk;
reg [1:0] detect_pipe;

// Clock gating logic
always @(*) begin
    gated_clk = clk & (|state); // Gate clock when in IDLE
end

// State transition logic
always @(*) begin
    next_state = IDLE;
    case (1'b1)
        state[0]: // IDLE
            next_state = data_in ? S1 : IDLE;
        state[1]: // S1
            next_state = data_in ? S1 : S10;
        state[2]: // S10
            next_state = data_in ? S1 : S100;
        state[3]: // S100
            next_state = data_in ? S1 : IDLE;
    endcase
end

// State register with gated clock
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Pipelined detection logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        detect_pipe <= 2'b00;
        sequence_detected <= 1'b0;
    end else begin
        detect_pipe[0] <= (state == S100) & data_in;
        detect_pipe[1] <= detect_pipe[0];
        sequence_detected <= detect_pipe[1];
    end
end

endmodule