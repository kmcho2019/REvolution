module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// State encoding
localparam IDLE = 3'b000;
localparam S1   = 3'b001;
localparam S2   = 3'b010;
localparam S3   = 3'b011;
localparam S4   = 3'b100;

reg [2:0] current_state;

// Combined state transition and output logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (current_state)
            IDLE: current_state <= data_in ? S1 : IDLE;
            S1:   current_state <= data_in ? S1 : S2;
            S2:   current_state <= data_in ? S1 : S3;
            S3:   current_state <= data_in ? S4 : IDLE;
            S4:   current_state <= data_in ? S1 : S2;
            default: current_state <= IDLE;
        endcase
        
        sequence_detected <= (current_state == S4);
    end
end

endmodule