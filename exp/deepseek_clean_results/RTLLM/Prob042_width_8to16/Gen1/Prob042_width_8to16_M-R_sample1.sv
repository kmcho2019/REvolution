module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
localparam IDLE = 1'b0;
localparam HAVE_FIRST_HALF = 1'b1;

reg state;
reg [7:0] first_half;

// Next state and output logic
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        first_half <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (valid_in) begin
                    first_half <= data_in;
                    state <= HAVE_FIRST_HALF;
                end
                valid_out <= 1'b0;
            end
            
            HAVE_FIRST_HALF: begin
                if (valid_in) begin
                    data_out <= {first_half, data_in};
                    valid_out <= 1'b1;
                    state <= IDLE;
                end
                else begin
                    valid_out <= 1'b0;
                end
            end
        endcase
    end
end

endmodule