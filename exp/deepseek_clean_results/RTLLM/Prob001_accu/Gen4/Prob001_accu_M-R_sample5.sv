module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding
    localparam [1:0] S0 = 2'b00,  // 0 inputs received
                     S1 = 2'b01,  // 1 input received
                     S2 = 2'b10,  // 2 inputs received
                     S3 = 2'b11;  // 3 inputs received

    reg [1:0] state, next_state;
    reg [9:0] accum_reg, next_accum;
    wire [9:0] accum_plus_input = accum_reg + data_in;

    // State transition and accumulation logic
    always @(*) begin
        next_state = state;
        next_accum = accum_reg;
        valid_out = 1'b0;
        data_out = 10'b0;

        if (valid_in) begin
            case (state)
                S0: begin
                    next_state = S1;
                    next_accum = data_in;
                end
                S1: begin
                    next_state = S2;
                    next_accum = accum_plus_input;
                end
                S2: begin
                    next_state = S3;
                    next_accum = accum_plus_input;
                end
                S3: begin
                    next_state = S0;
                    data_out = accum_plus_input;
                    valid_out = 1'b1;
                    next_accum = 10'b0;
                end
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            accum_reg <= 10'b0;
        end
        else begin
            state <= next_state;
            accum_reg <= next_accum;
        end
    end

endmodule