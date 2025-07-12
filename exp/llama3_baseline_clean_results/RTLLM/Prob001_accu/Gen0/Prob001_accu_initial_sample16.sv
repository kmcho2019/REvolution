module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output           valid_out,
    output     [9:0] data_out
);

reg [1:0] state; // 2-bit state variable for FSM
reg [1:0] count; // counter for valid input data
reg [9:0] sum;   // accumulator for input data
reg [9:0] data_out_reg; // register for output data

// Define states for FSM
localparam IDLE = 2'b00;
localparam ACCU = 2'b01;
localparam OUTPUT = 2'b10;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        count <= 2'b00;
        sum <= 10'b0;
        valid_out <= 1'b0;
        data_out_reg <= 10'b0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    state <= ACCU;
                    count <= 2'b01;
                    sum <= data_in;
                end else begin
                    state <= IDLE;
                end
            end
            ACCU: begin
                if (valid_in) begin
                    count <= count + 1'b1;
                    sum <= sum + data_in;
                    if (count == 2'b11) begin
                        state <= OUTPUT;
                    end else begin
                        state <= ACCU;
                    end
                end else begin
                    state <= IDLE;
                    count <= 2'b00;
                    sum <= 10'b0;
                end
            end
            OUTPUT: begin
                valid_out <= 1'b1;
                data_out_reg <= sum;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Combinational logic for output
always @(*) begin
    if (state == OUTPUT) begin
        valid_out = 1'b1;
    end else begin
        valid_out = 1'b0;
    end
    data_out = data_out_reg;
end

endmodule