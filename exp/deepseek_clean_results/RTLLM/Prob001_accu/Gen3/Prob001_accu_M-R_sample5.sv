module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        ACCUM,
        OUTPUT
    } state_t;

    reg [1:0] state, next_state;
    reg [1:0] count;
    reg [9:0] accum_reg;
    wire [9:0] next_accum = accum_reg + data_in;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accum_reg <= 10'b0;
            count <= 2'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            
            // Only update registers when valid
            if (valid_in) begin
                case (state)
                    IDLE: begin
                        accum_reg <= data_in;
                        count <= 2'b1;
                    end
                    ACCUM: begin
                        accum_reg <= next_accum;
                        count <= count + 1'b1;
                    end
                    OUTPUT: begin
                        accum_reg <= data_in; // Start new accumulation
                        count <= 2'b1;
                    end
                endcase
            end
            
            // Output generation
            if (state == OUTPUT && valid_in) begin
                data_out <= next_accum;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (valid_in) next_state = ACCUM;
            ACCUM: if (valid_in && count == 2'b11) next_state = OUTPUT;
            OUTPUT: if (valid_in) next_state = ACCUM;
        endcase
    end

endmodule