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
        COUNT1,
        COUNT2,
        COUNT3
    } state_t;

    state_t current_state, next_state;
    reg [9:0] accumulator;
    wire [9:0] next_accumulator;
    wire output_valid;

    // Combinational next state and accumulator logic
    always_comb begin
        next_state = current_state;
        next_accumulator = accumulator;
        output_valid = 1'b0;

        if (valid_in) begin
            case (current_state)
                IDLE: begin
                    next_state = COUNT1;
                    next_accumulator = data_in;
                end
                COUNT1: begin
                    next_state = COUNT2;
                    next_accumulator = accumulator + data_in;
                end
                COUNT2: begin
                    next_state = COUNT3;
                    next_accumulator = accumulator + data_in;
                end
                COUNT3: begin
                    next_state = IDLE;
                    next_accumulator = 10'b0;
                    output_valid = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            accumulator <= 10'b0;
            data_out <= 10'b0;
        end
        else begin
            current_state <= next_state;
            accumulator <= next_accumulator;
            
            // Capture output when valid
            if (output_valid) begin
                data_out <= accumulator + data_in;
            end
        end
    end

    // Valid output is purely combinational
    assign valid_out = output_valid;

endmodule