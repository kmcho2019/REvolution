module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Simple binary state encoding
reg [1:0] state;

// State definitions
localparam IDLE   = 2'b00;
localparam GOT_0  = 2'b01;
localparam GOT_01 = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                data_out <= 0;
                if (data_in == 0)
                    state <= GOT_0;
            end
            
            GOT_0: begin
                data_out <= 0;
                if (data_in == 1)
                    state <= GOT_01;
                else if (data_in == 0)
                    state <= GOT_0;
            end
            
            GOT_01: begin
                if (data_in == 0) begin
                    data_out <= 1;
                    state <= IDLE;
                end else begin
                    data_out <= 0;
                    state <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule