module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// One-hot state encoding for better timing
localparam IDLE   = 3'b001;
localparam GOT_0  = 3'b010;
localparam GOT_01 = 3'b100;

reg [2:0] state, next_state;

// State transition logic
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    // Default assignments
    next_state = state;
    data_out = 1'b0;
    
    case (state)
        IDLE: begin
            if (!data_in) next_state = GOT_0;
        end
        GOT_0: begin
            if (data_in) next_state = GOT_01;
            else next_state = GOT_0;
        end
        GOT_01: begin
            if (!data_in) begin
                next_state = IDLE;
                data_out = 1'b1;
            end else begin
                next_state = GOT_01;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule