module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        ACCUMULATING,
        OUTPUT
    } state_t;

    state_t current_state, next_state;
    reg [1:0] counter;
    reg [9:0] accumulator;

    // State transition logic (combinational)
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: 
                if (valid_in)
                    next_state = ACCUMULATING;
            
            ACCUMULATING:
                if (counter == 2'b11 && valid_in)
                    next_state = OUTPUT;
            
            OUTPUT:
                next_state = IDLE;
        endcase
    end

    // Sequential logic (state and registers)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            counter <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            current_state <= next_state;
            
            // Default outputs
            valid_out <= 1'b0;
            
            case (current_state)
                IDLE: begin
                    if (valid_in) begin
                        accumulator <= data_in;
                        counter <= 2'b01;
                    end
                end
                
                ACCUMULATING: begin
                    if (valid_in) begin
                        accumulator <= accumulator + data_in;
                        counter <= counter + 1'b1;
                    end
                end
                
                OUTPUT: begin
                    data_out <= accumulator;
                    valid_out <= 1'b1;
                    counter <= 2'b00;
                    accumulator <= 10'b0;
                end
            endcase
        end
    end

endmodule