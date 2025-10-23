module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define the states of the FSM
localparam IDLE = 2'b00;
localparam RISING = 2'b01;
localparam HIGH = 2'b10;
localparam FALLING = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

// Sequential logic
always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    data_out <= 0;
                    state <= RISING;
                end else begin
                    data_out <= 0;
                    state <= IDLE;
                end
            end
            RISING: begin
                if (data_in) begin
                    data_out <= 0;
                    state <= HIGH;
                end else begin
                    data_out <= 0;
                    state <= IDLE;
                end
            end
            HIGH: begin
                if (data_in) begin
                    data_out <= 0;
                    state <= HIGH;
                end else begin
                    data_out <= 1;
                    state <= FALLING;
                end
            end
            FALLING: begin
                data_out <= 0;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Combinational logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in) next_state = RISING;
            else next_state = IDLE;
        end
        RISING: begin
            if (data_in) next_state = HIGH;
            else next_state = IDLE;
        end
        HIGH: begin
            if (data_in) next_state = HIGH;
            else next_state = FALLING;
        end
        FALLING: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule