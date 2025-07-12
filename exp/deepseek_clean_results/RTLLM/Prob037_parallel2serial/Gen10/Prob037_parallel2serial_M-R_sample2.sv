module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // One-hot state encoding
    reg [3:0] state;
    reg [3:0] data_reg;

    // State definitions
    localparam S0 = 4'b0001;
    localparam S1 = 4'b0010;
    localparam S2 = 4'b0100;
    localparam S3 = 4'b1000;

    // Combinational outputs
    assign dout = (state == S0) ? data_reg[3] :
                  (state == S1) ? data_reg[2] :
                  (state == S2) ? data_reg[1] :
                  data_reg[0];
    
    assign valid_out = (state == S0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            data_reg <= 4'b0;
        end else begin
            case (state)
                S0: begin
                    data_reg <= d;
                    state <= S1;
                end
                S1: state <= S2;
                S2: state <= S3;
                S3: state <= S0;
                default: state <= S0;
            endcase
        end
    end

endmodule