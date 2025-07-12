module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states of the FSM
enum logic [1:0] {
    SEARCH,
    RECEIVE_BYTE1,
    RECEIVE_BYTE2,
    RECEIVE_BYTE3
} state, next_state;

// Define the datapath registers
logic [23:0] out_bytes_reg;
logic [7:0] byte1_reg, byte2_reg, byte3_reg;

// Combinational logic to determine the next state
always_comb begin
    case(state)
        SEARCH: begin
            if (in[3]) begin
                next_state = RECEIVE_BYTE1;
            end else begin
                next_state = SEARCH;
            end
        end
        RECEIVE_BYTE1: begin
            next_state = RECEIVE_BYTE2;
        end
        RECEIVE_BYTE2: begin
            next_state = RECEIVE_BYTE3;
        end
        RECEIVE_BYTE3: begin
            next_state = RECEIVE_BYTE3;
        end
        default: begin
            next_state = SEARCH;
        end
    endcase
end

// Sequential logic to update the state and datapath registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        out_bytes_reg <= 24'd0;
        byte1_reg <= 8'd0;
        byte2_reg <= 8'd0;
        byte3_reg <= 8'd0;
    end else begin
        state <= next_state;
        case(state)
            SEARCH: begin
                if (in[3]) begin
                    byte1_reg <= in;
                end
            end
            RECEIVE_BYTE1: begin
                byte2_reg <= in;
            end
            RECEIVE_BYTE2: begin
                byte3_reg <= in;
            end
            RECEIVE_BYTE3: begin
                out_bytes_reg <= {byte1_reg, byte2_reg, byte3_reg};
            end
            default: begin
            end
        endcase
    end
end

// Output logic
assign out_bytes = out_bytes_reg;
assign done = (state == RECEIVE_BYTE3);

endmodule