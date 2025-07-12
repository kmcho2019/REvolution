module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] buffer;
    reg [2:0] bit_count;
    reg state;
    reg valid_pulse;

    localparam COLLECT = 1'b0;
    localparam OUTPUT  = 1'b1;

    assign dout_valid = valid_pulse;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= {WIDTH{1'b0}};
            dout_parallel <= {WIDTH{1'b0}};
            bit_count <= 3'b0;
            valid_pulse <= 1'b0;
            state <= COLLECT;
        end
        else begin
            valid_pulse <= 1'b0;  // Default
            
            case (state)
                COLLECT: begin
                    if (din_valid) begin
                        buffer <= {buffer[WIDTH-2:0], din_serial};
                        
                        if (bit_count == WIDTH-1) begin
                            state <= OUTPUT;
                            bit_count <= 3'b0;
                        end
                        else begin
                            bit_count <= bit_count + 1'b1;
                        end
                    end
                end

                OUTPUT: begin
                    dout_parallel <= buffer;
                    valid_pulse <= 1'b1;
                    state <= COLLECT;
                end
            endcase
        end
    end

endmodule