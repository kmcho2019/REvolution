module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

// Define the states for the FSM
enum logic [1:0] {
    IDLE,
    SHIFT0,
    SHIFT1,
    SHIFT2
} state, next_state;

// Counter to keep track of the current bit position
reg [1:0] cnt;

// Register to hold the input data
reg [3:0] data_reg;

// Sequential logic for the FSM and counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= 0;
        data_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (cnt == 0) begin
                    data_reg <= d;
                    state <= SHIFT0;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT0: begin
                state <= SHIFT1;
                cnt <= cnt + 1;
            end
            SHIFT1: begin
                state <= SHIFT2;
                cnt <= cnt + 1;
            end
            SHIFT2: begin
                state <= IDLE;
                cnt <= 0;
            end
        endcase
    end
end

// Combinational logic for the valid signal and serial output
always @(*) begin
    case (state)
        IDLE: begin
            valid_out = (cnt == 0) ? 1 : 0;
            dout = data_reg[3];
        end
        SHIFT0: begin
            valid_out = 0;
            dout = data_reg[2];
        end
        SHIFT1: begin
            valid_out = 0;
            dout = data_reg[1];
        end
        SHIFT2: begin
            valid_out = 0;
            dout = data_reg[0];
        end
    endcase
end

endmodule