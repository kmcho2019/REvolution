module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // FSM states
    typedef enum logic [1:0] {
        S0, S1, S2, S3
    } state_t;

    state_t current_state, next_state;
    reg [3:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
            data_reg <= 4'b0;
            dout <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            current_state <= next_state;
            
            case (current_state)
                S0: begin
                    data_reg <= d;
                    dout <= d[3];
                    valid_out <= 1'b1;
                end
                S1: begin
                    dout <= data_reg[2];
                    valid_out <= 1'b0;
                end
                S2: begin
                    dout <= data_reg[1];
                    valid_out <= 1'b0;
                end
                S3: begin
                    dout <= data_reg[0];
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S0;
            default: next_state = S0;
        endcase
    end

endmodule