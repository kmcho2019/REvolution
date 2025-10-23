module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Parameters for states
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Registers for state and internal counter
logic [1:0] state;
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// Always block for state transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
            s2_yellow: if (cnt == 0) state <= s1_red;
            s3_green: if (cnt == 0) state <= s2_yellow;
            default: state <= idle;
        endcase
    end
end

// Always block for counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            s1_red: if (p_red == 1'b0) cnt <= 10;
            s2_yellow: if (p_yellow == 1'b0) cnt <= 5;
            s3_green: if (p_green == 1'b0) cnt <= 60;
            default: ;
        endcase
        
        if (pass_request && p_green) cnt <= 10;
        
        if (cnt > 0) cnt <= cnt - 1;
        
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

// Always block for output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            s1_red: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s2_yellow: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            s3_green: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
            default: ;
        endcase
    end
end

// Assign statement for output clock
assign clock = cnt;

endmodule