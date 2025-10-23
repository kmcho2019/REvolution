module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output wire [15:0] data_out
);

// State encoding
localparam IDLE = 1'b0;
localparam HAVE_FIRST_BYTE = 1'b1;

reg state;
reg [7:0] first_byte_reg;
reg [15:0] data_out_reg;

// Combinational outputs
assign valid_out = (state == HAVE_FIRST_BYTE) && valid_in;
assign data_out = (state == HAVE_FIRST_BYTE) ? {first_byte_reg, data_in} : data_out_reg;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte_reg <= 8'b0;
        data_out_reg <= 16'b0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_byte_reg <= data_in;
                    state <= HAVE_FIRST_BYTE;
                end
            end
            
            HAVE_FIRST_BYTE: begin
                if (valid_in) begin
                    data_out_reg <= {first_byte_reg, data_in};
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule