module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Define states
parameter IDLE = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;

reg [3:0] current_state;
reg [3:0] next_state;

// Assign initial state
initial begin
    current_state = IDLE;
    sequence_detected = 1'b0;
end

// FSM logic
always @(*) begin
    case(current_state)
        IDLE: begin
            if(data_in == 1'b1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if(data_in == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if(data_in == 1'b0)
                next_state = S2;
            else
                next_state = S3;
        end
        S3: begin
            if(data_in == 1'b1)
                next_state = S4;
            else
                next_state = IDLE;
        end
        S4: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Update state on clock edge
always @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        current_state <= next_state;
        if(current_state == S4)
            sequence_detected <= 1'b1;
        else
            sequence_detected <= 1'b0;
    end
end

endmodule