module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Define the states of the traffic light controller
parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

// Define the registers and wires
reg [1:0] state, next_state;
reg [7:0] cnt_red, cnt_yellow, cnt_green;

// Red state module
module red_state(
    input rst_n,
    input clk,
    input en,
    output reg red,
    output [7:0] cnt
);
    reg [7:0] cnt_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_reg <= 10;
            red <= 0;
        end else if (en) begin
            if (cnt_reg == 0) begin
                cnt_reg <= 10;
            end else begin
                cnt_reg <= cnt_reg - 1;
            end
            red <= 1;
        end else begin
            red <= 0;
        end
    end
    assign cnt = cnt_reg;
endmodule

// Yellow state module
module yellow_state(
    input rst_n,
    input clk,
    input en,
    output reg yellow,
    output [7:0] cnt
);
    reg [7:0] cnt_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_reg <= 5;
            yellow <= 0;
        end else if (en) begin
            if (cnt_reg == 0) begin
                cnt_reg <= 5;
            end else begin
                cnt_reg <= cnt_reg - 1;
            end
            yellow <= 1;
        end else begin
            yellow <= 0;
        end
    end
    assign cnt = cnt_reg;
endmodule

// Green state module
module green_state(
    input rst_n,
    input clk,
    input en,
    output reg green,
    output [7:0] cnt
);
    reg [7:0] cnt_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_reg <= 60;
            green <= 0;
        end else if (en) begin
            if (cnt_reg == 0) begin
                cnt_reg <= 60;
            end else if (pass_request && cnt_reg > 10) begin
                cnt_reg <= 10;
            end else begin
                cnt_reg <= cnt_reg - 1;
            end
            green <= 1;
        end else begin
            green <= 0;
        end
    end
    assign cnt = cnt_reg;
endmodule

// Instantiate the state modules
red_state u_red(.rst_n(rst_n), .clk(clk), .en(state == s1_red), .red(red), .cnt(cnt_red));
yellow_state u_yellow(.rst_n(rst_n), .clk(clk), .en(state == s2_yellow), .yellow(yellow), .cnt(cnt_yellow));
green_state u_green(.rst_n(rst_n), .clk(clk), .en(state == s3_green), .green(green), .cnt(cnt_green));

// Top-level state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt_red == 0) state <= s3_green; else state <= s1_red;
            s2_yellow: if (cnt_yellow == 0) state <= s1_red; else state <= s2_yellow;
            s3_green: if (cnt_green == 0) state <= s2_yellow; else state <= s3_green;
            default: state <= idle;
        endcase
    end
end

// Assign the output clock
assign clock = (state == s1_red) ? cnt_red : (state == s2_yellow) ? cnt_yellow : (state == s3_green) ? cnt_green : 0;

endmodule